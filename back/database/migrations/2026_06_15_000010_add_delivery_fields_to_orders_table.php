<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->string('delivery_address')->nullable()->after('payment_reference');
            $table->string('city')->nullable()->after('delivery_address');
            $table->string('area')->nullable()->after('city');
            $table->string('contact_phone')->nullable()->after('area');
        });
    }

    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn([
                'delivery_address',
                'city',
                'area',
                'contact_phone',
            ]);
        });
    }
};
