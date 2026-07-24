<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class DoctorMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        if (! auth()->check()) {
            return redirect()->route('doctor.login');
        }

        if (auth()->user()->role !== 'doctor' || ! auth()->user()->is_active) {
            abort(403);
        }

        return $next($request);
    }
}
