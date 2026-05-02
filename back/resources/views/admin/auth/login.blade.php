<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>

<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">

            <div class="card">

                <div class="card-header text-center">
                    <h4>Admin Login</h4>
                </div>

                <div class="card-body">

                    <form method="POST" action="/admin/login">
                        @csrf

                        <div class="mb-3">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control">
                        </div>

                        <div class="mb-3">
                            <label>Password</label>
                            <input type="password" name="password" class="form-control">
                        </div>

                        <button class="btn btn-primary w-100">
                            Login
                        </button>
                    </form>

                    @if ($errors->any())
                        <div class="alert alert-danger mt-3">
                            {{ $errors->first() }}
                        </div>
                    @endif

                </div>

            </div>

        </div>
    </div>
</div>

</body>
</html>
