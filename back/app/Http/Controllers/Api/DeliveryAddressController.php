<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreDeliveryAddressRequest;
use App\Http\Requests\Api\UpdateDeliveryAddressRequest;
use App\Http\Resources\DeliveryAddressResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DeliveryAddressController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $addresses = $request->user()
            ->deliveryAddresses()
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Delivery addresses loaded successfully.',
            'data' => DeliveryAddressResource::collection($addresses),
        ]);
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $deliveryAddress = $request->user()
            ->deliveryAddresses()
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'message' => 'Delivery address loaded successfully.',
            'data' => new DeliveryAddressResource($deliveryAddress),
        ]);
    }

    public function store(StoreDeliveryAddressRequest $request): JsonResponse
    {
        $deliveryAddress = $request->user()
            ->deliveryAddresses()
            ->create($request->validated());

        return response()->json([
            'success' => true,
            'message' => 'Delivery address created successfully.',
            'data' => new DeliveryAddressResource($deliveryAddress),
        ], 201);
    }

    public function update(
        UpdateDeliveryAddressRequest $request,
        int $id
    ): JsonResponse {
        $deliveryAddress = $request->user()
            ->deliveryAddresses()
            ->findOrFail($id);

        $deliveryAddress->update($request->validated());

        return response()->json([
            'success' => true,
            'message' => 'Delivery address updated successfully.',
            'data' => new DeliveryAddressResource($deliveryAddress->fresh()),
        ]);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $deliveryAddress = $request->user()
            ->deliveryAddresses()
            ->findOrFail($id);

        $deliveryAddress->delete();

        return response()->json([
            'success' => true,
            'message' => 'Delivery address deleted successfully.',
        ]);
    }
}
