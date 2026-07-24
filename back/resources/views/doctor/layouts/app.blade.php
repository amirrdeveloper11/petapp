<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Doctor - @yield('title', 'Dashboard')</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-success">
    <div class="container">
        <a class="navbar-brand fw-bold" href="{{ route('doctor.dashboard') }}">Pet Clinic Doctor</a>

        <div class="navbar-nav ms-3">
            <a class="nav-link" href="{{ route('doctor.dashboard') }}">Dashboard</a>
            <a class="nav-link" href="{{ route('doctor.schedule.index') }}">Working Hours</a>
            <a class="nav-link" href="{{ route('doctor.appointments.index') }}">Appointments</a>
        </div>

        <div class="ms-auto">
            @auth
                <form method="POST" action="{{ route('doctor.logout') }}">
                    @csrf
                    <button class="btn btn-danger btn-sm">Logout</button>
                </form>
            @endauth
        </div>
    </div>
</nav>

<div class="container py-4">
    @if($errors->any())
        <div class="alert alert-danger">
            <ul class="mb-0">
                @foreach($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    @yield('content')
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
