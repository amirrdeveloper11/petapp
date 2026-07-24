<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('appointments', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained('users')
                ->noActionOnDelete();

            $table->foreignId('pet_id')
                ->nullable()
                ->constrained('pets')
                ->nullOnDelete();

            $table->foreignId('doctor_profile_id')
                ->constrained('doctor_profiles')
                ->noActionOnDelete();

            $table->date('appointment_date');
            $table->time('appointment_time');
            $table->unsignedSmallInteger('duration_minutes')->default(30);

            $table->string('status', 30)
                ->default('pending')
                ->index();

            $table->text('reason');
            $table->text('consultation_notes')->nullable();
            $table->text('rejection_reason')->nullable();
            $table->timestamp('accepted_at')->nullable();
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();

            $table->index(['doctor_profile_id', 'appointment_date']);
            $table->index(['user_id', 'appointment_date']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('appointments');
    }
};
