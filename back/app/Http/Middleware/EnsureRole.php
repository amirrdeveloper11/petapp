<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureRole
{
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        if (! auth()->check()) {
            return $this->redirectForGuest($request, $roles);
        }

        $user = auth()->user();

        if (! $user->is_active) {
            auth()->logout();
            $request->session()->invalidate();
            $request->session()->regenerateToken();

            abort(403, 'Your account is inactive.');
        }

        if (! in_array($user->role, $roles, true)) {
            abort(403, 'Unauthorized access.');
        }

        return $next($request);
    }

    protected function redirectForGuest(Request $request, array $roles): Response
    {
        if ($request->expectsJson()) {
            abort(401, 'Unauthenticated.');
        }

        if (in_array('admin', $roles, true)) {
            return redirect()->route('admin.login');
        }

        if (in_array('doctor', $roles, true)) {
            return redirect()->route('doctor.login');
        }

        return redirect()->route('login');
    }
}
