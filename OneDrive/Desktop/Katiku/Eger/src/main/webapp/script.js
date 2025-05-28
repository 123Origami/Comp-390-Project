// Handle Profile Menu and Bottom Nav
document.addEventListener("DOMContentLoaded", () => {
    // Toggle Password Visibility
    const toggleIcon = document.querySelector(".toggle-password");
    const passwordField = document.getElementById("password");

    if (toggleIcon && passwordField) {
        toggleIcon.addEventListener("click", () => {
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.textContent = "🙈";
            } else {
                passwordField.type = "password";
                toggleIcon.textContent = "👁️";
            }
        });
    }

    // Profile Menu Navigation
    document.querySelectorAll(".profile-menu li").forEach(item => {
        item.addEventListener("click", function () {
            const action = this.getAttribute("data-action");

            switch (action) {
                case "logout":
                    window.location.href = "logout.jsp";
                    break;
                case "history":
                    window.location.href = "history.jsp";
                    break;
                case "personal-details":
                    window.location.href = "personal_details.jsp";
                    break;
                case "settings":
                    window.location.href = "settings.jsp";
                    break;
                case "help":
                    window.location.href = "help.jsp";
                    break;
                default:
                    console.error(`Unknown action: ${action}`);
                    break;
            }
        });
    });

    // Bottom Navigation Menu
    document.querySelectorAll(".nav-item").forEach(item => {
        item.addEventListener("click", function () {
            const action = this.getAttribute("href");

            switch (action) {
                case "Home":
                    window.location.href = "home.jsp";
                    break;
                case "Appointments":
                    window.location.href = "appointment.jsp";
                    break;
                case "Chats":
                    window.location.href = "chats.jsp";
                    break;
                case "Profile":
                    window.location.href = "profile.jsp";
                    break;
                default:
                    console.error(`Unknown action: ${action}`);
                    break;
            }
        });
    });

    // Help Options
    const helpOptions = document.querySelectorAll(".help-option");
    const helpContent = document.getElementById("help-content");

    if (helpContent) {
        const helpData = {
            "faq": "<h3>Frequently Asked Questions</h3><p>Find answers to common questions about using this app.</p>",
            "contact-support": "<h3>Contact Support</h3><p>Email: support@example.com<br>Phone: +254 700 123 456</p>",
            "app-info": "<h3>About This App</h3><p>This is a health records management system built for efficiency and security.</p>"
        };

        helpOptions.forEach(option => {
            option.addEventListener("click", function () {
                const target = this.getAttribute("data-target");
                helpContent.innerHTML = helpData[target] || "<p>Content not available.</p>";
            });
        });
    }
});

// Confirm Logout
function confirmLogout() {
    window.location.href = "login.jsp";
}

// Go Back to Profile Page
function goBack() {
    window.location.href = "profile.jsp";
}
