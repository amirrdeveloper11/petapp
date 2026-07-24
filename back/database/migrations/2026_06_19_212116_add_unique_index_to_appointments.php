<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (DB::getDriverName() !== 'sqlsrv') {
            return;
        }

        $this->dropIndexIfExists('doctor_schedule_unique');

        if (! $this->indexExists('appointments_active_booking_unique')) {
            DB::statement("
                CREATE UNIQUE INDEX [appointments_active_booking_unique]
                ON [dbo].[appointments] ([doctor_profile_id], [appointment_date], [appointment_time])
                WHERE [status] IN ('pending', 'accepted')
            ");
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() !== 'sqlsrv') {
            return;
        }

        $this->dropIndexIfExists('appointments_active_booking_unique');

        if (! $this->indexExists('doctor_schedule_unique')) {
            Schema::table('appointments', function (Blueprint $table) {
                $table->unique(
                    ['doctor_profile_id', 'appointment_date', 'appointment_time'],
                    'doctor_schedule_unique'
                );
            });
        }
    }

    protected function dropIndexIfExists(string $indexName): void
    {
        if (DB::getDriverName() !== 'sqlsrv') {
            return;
        }

        if (! $this->indexExists($indexName)) {
            return;
        }

        DB::statement("DROP INDEX [{$indexName}] ON [dbo].[appointments]");
    }

    protected function indexExists(string $indexName): bool
    {
        if (DB::getDriverName() !== 'sqlsrv') {
            return false;
        }

        $row = DB::selectOne(
            "SELECT 1 AS existing_index
             FROM sys.indexes
             WHERE name = ? AND object_id = OBJECT_ID(N'dbo.appointments')",
            [$indexName]
        );

        return (bool) $row;
    }
};
