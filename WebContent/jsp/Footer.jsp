<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome per le icone -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    :root {
        --color-primary:   #2C6FA0;
        --color-secondary: #4BA3A7;
        --color-accent:    #A6D4C9;
        --color-bg:        #F5F2EA;
        --color-neutral-d: #708090;
        --color-neutral-l: #E8E7E3;
    }

    footer {
        background-color: var(--color-bg);
        padding: 3rem 0;
        margin-top: 3rem;
        border-top: 1px solid var(--color-accent);
    }

    .newsletter-section {
        background-color: var(--color-neutral-l);
        padding: 2rem;
        border-radius: 0.5rem;
        margin-bottom: 2rem;
    }

    .newsletter-section h4,
    .newsletter-section p {
        color: var(--color-neutral-d);
    }

    .form-control {
        border-color: var(--color-accent);
    }

    .form-control:focus {
        border-color: var(--color-primary);
        box-shadow: 0 0 0 0.2rem rgba(44, 111, 160, 0.25);
    }

    .btn-primary {
        background-color: var(--color-primary);
        border-color: var(--color-primary);
    }

    .btn-primary:hover {
        background-color: var(--color-secondary);
        border-color: var(--color-secondary);
    }

    .social-icons a {
        color: var(--color-neutral-d);
        font-size: 1.5rem;
        margin-right: 1rem;
        transition: color 0.3s;
    }

    .social-icons a:hover {
        color: var(--color-primary);
    }

    .footer-links a {
        color: var(--color-neutral-d);
        text-decoration: none;
        margin-right: 1rem;
    }

    .footer-links a:hover {
        color: var(--color-primary);
        text-decoration: underline;
    }

    .payment-methods i {
        color: var(--color-primary);
        font-size: 1.4rem;
    }
</style>
</head>
<body>

    <!-- Contenuto principale -->

    <!-- Footer -->
    <footer class="container-fluid">
        <div class="container">
            <!-- Newsletter -->
            <div class="newsletter-section">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h4>Iscriviti alla nostra Newsletter</h4>
                        <p>Ricevi offerte esclusive, novità e aggiornamenti direttamente nella tua casella di posta.</p>
                    </div>
                    <div class="col-md-6">
                        <form class="row g-2">
                            <div class="col-8">
                                <input type="email" class="form-control" placeholder="Il tuo indirizzo email" required>
                            </div>
                            <div class="col-4">
                                <button type="submit" class="btn btn-primary w-100">Iscriviti</button>
                            </div>
                            <div class="col-12">
                                <div class="form-check mt-2">
                                    <input class="form-check-input" type="checkbox" id="privacyCheck" required>
                                    <label class="form-check-label small" for="privacyCheck">
                                        Accetto l'informativa sulla privacy
                                    </label>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Link e Social -->
            <div class="row">
                <div class="col-md-6">
                    <div class="footer-links mb-3">
                        <a href="#">Privacy</a>
                        <a href="#">Termini d'uso</a>
                        <a href="#">Cookie</a>
                        <a href="#">Contatti</a>
                    </div>
                    <p class="small text-muted">© 2025 Bookstore. Tutti i diritti riservati.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <div class="social-icons mb-3">
                        <span class="me-2">Seguici su:</span>
                        <a href="#"><i class="fab fa-facebook"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-pinterest"></i></a>
                    </div>
                    <div class="payment-methods">
                        <span class="me-2">Pagamenti sicuri con:</span>
                        <i class="fab fa-cc-visa me-2"></i>
                        <i class="fab fa-cc-mastercard me-2"></i>
                        <i class="fab fa-cc-paypal me-2"></i>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
