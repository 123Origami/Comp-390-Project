
document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".profile-menu li").forEach(item => {
        item.addEventListener("click", function () {
            const action = this.getAttribute("data-action");
            
            // Redirect based on the clicked menu option
            if (action === "history") {
                window.location.href = "history.jsp";
            } else if (action === "personal_details") {
                window.location.href = "personal_details.jsp"; 
            } else if (action === "settings") {
                window.location.href = "settings.jsp";
            } else if (action === "help") {
                window.location.href = "help.jsp";
            } else if (action === "logout") {
                window.location.href = "logout.jsp";
            }
        });
     });
});