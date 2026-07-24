<?php

namespace App\Http\Controllers;

use App\Models\RefreshToken;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6|confirmed',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'role' => 'user',
            'is_active' => true,
        ]);

        $token = $user->createToken('access_token')->plainTextToken;
        $refreshToken = RefreshToken::generate($user);

        return response()->json([
            'status' => 'success',
            'data' => [
                'user' => $user,
                'access_token' => $token,
                'refresh_token' => $refreshToken->plainTextToken,
            ],
        ], 201);
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $validated['email'])
            ->where('role', 'user')
            ->where('is_active', true)
            ->first();

        if (! $user || ! Hash::check($validated['password'], $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Invalid credentials or unauthorized account type.'],
            ]);
        }

        $token = $user->createToken('access_token')->plainTextToken;
        $refreshToken = RefreshToken::generate($user);

        return response()->json([
            'status' => 'success',
            'data' => [
                'user' => $user,
                'access_token' => $token,
                'refresh_token' => $refreshToken->plainTextToken,
            ],
        ]);
    }

    public function refresh(Request $request)
    {
        $validated = $request->validate([
            'refresh_token' => 'required|string',
        ]);

        $refreshToken = RefreshToken::findByPlainToken($validated['refresh_token']);

        if (! $refreshToken || $refreshToken->isExpired() || $refreshToken->revoked) {
            return response()->json([
                'message' => 'Invalid or expired refresh token',
            ], 401);
        }

        $user = $refreshToken->user;

        if (! $user || $user->role !== 'user' || ! $user->is_active) {
            return response()->json([
                'message' => 'Unauthorized account type',
            ], 403);
        }

        $refreshToken->update([
            'expires_at' => now()->addDays(7),
        ]);

        $accessToken = $user->createToken('access_token')->plainTextToken;

        return response()->json([
            'status' => 'success',
            'data' => [
                'user' => $user,
                'access_token' => $accessToken,
                'refresh_token' => $request->input('refresh_token'),
            ],
        ]);
    }

    public function logout(Request $request)
    {
        $user = $request->user();

        if (! $user) {
            return response()->json([
                'message' => 'Unauthenticated.',
            ], 401);
        }

        if ($user->role !== 'user') {
            return response()->json([
                'message' => 'Unauthorized account type.',
            ], 403);
        }

        $user->tokens()->delete();

        RefreshToken::where('user_id', $user->id)->update([
            'revoked' => true,
        ]);

        return response()->json([
            'message' => 'Logged out successfully',
        ]);
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();

        if (! $user) {
            return response()->json([
                'message' => 'Unauthenticated.',
            ], 401);
        }

        if ($user->role !== 'user') {
            return response()->json([
                'message' => 'Unauthorized account type.',
            ], 403);
        }

        $validated = $request->validate([
            'name' => 'sometimes|string|max:100',
            'email' => 'sometimes|email|unique:users,email,' . $user->id,
            'password' => 'sometimes|string|min:6|confirmed',
        ]);

        if (array_key_exists('name', $validated)) {
            $user->name = $validated['name'];
        }

        if (array_key_exists('email', $validated)) {
            $user->email = $validated['email'];
        }

        if (array_key_exists('password', $validated)) {
            $user->password = Hash::make($validated['password']);
        }

        $user->save();

        return response()->json([
            'status' => 'success',
            'data' => [
                'user' => $user,
            ],
        ]);
    }

    public function deleteAccount(Request $request)
    {
        $user = $request->user();

        if (! $user) {
            return response()->json([
                'message' => 'Unauthenticated.',
            ], 401);
        }

        if ($user->role !== 'user') {
            return response()->json([
                'message' => 'Unauthorized account type.',
            ], 403);
        }

        DB::transaction(function () use ($user) {
            $user->appointments()->delete();

            $user->tokens()->delete();

            RefreshToken::where('user_id', $user->id)->update([
                'revoked' => true,
            ]);

            $user->delete();
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Account deleted successfully',
        ]);
    }
}
