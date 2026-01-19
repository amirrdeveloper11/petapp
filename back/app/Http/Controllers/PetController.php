<?php

namespace App\Http\Controllers;

use App\Models\Pet;
use Illuminate\Http\Request;

class PetController extends Controller
{
    public function index(Request $request)
    {
        return response()->json([
            'status' => 'success',
            'data' => $request->user()->pets,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:100',
            'type' => 'required|string|max:50',
            'breed' => 'nullable|string|max:100',
            'birth_date' => 'required|date',
            'gender' => 'required|in:male,female',
            'weight' => 'nullable|numeric',
            'image_path' => 'nullable|string',
        ]);

        $pet = $request->user()->pets()->create($validated);

        return response()->json([
            'status' => 'success',
            'data' => $pet,
        ], 201);
    }

    public function show(Request $request, $id)
    {
        $pet = $request->user()->pets()->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $pet,
        ]);
    }

    public function update(Request $request, $id)
    {
        $pet = $request->user()->pets()->findOrFail($id);

        $validated = $request->validate([
            'name' => 'sometimes|string|max:100',
            'type' => 'sometimes|string|max:50',
            'breed' => 'nullable|string|max:100',
            'birth_date' => 'sometimes|date',
            'gender' => 'sometimes|in:male,female',
            'weight' => 'nullable|numeric',
            'image_path' => 'nullable|string',
        ]);

        $pet->update($validated);

        return response()->json([
            'status' => 'success',
            'data' => $pet,
        ]);
    }

    public function destroy(Request $request, $id)
    {
        $pet = $request->user()->pets()->findOrFail($id);
        $pet->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Pet deleted successfully',
        ]);
    }
}
