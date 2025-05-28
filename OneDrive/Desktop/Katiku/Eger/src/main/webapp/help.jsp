<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Support</title>
    <link rel="stylesheet" href="help.css"> 
</head>
<body>

    <div class="header">
        <h2>Help & Support</h2>
    </div>

    <div class="details-container">
        <ul class="profile-menu">
            <li class="help-option" data-target="faq">
                <img src="Help Icon.png" class="menu-icon" style="width: 20px; vertical-align: middle; margin-right: 10px;"> FAQs
            </li>
            <li class="help-option" data-target="contact-support">
                <img src="Help Icon.png" class="menu-icon" style="width: 20px; vertical-align: middle; margin-right: 10px;"> Contact Support
            </li>
            <li class="help-option" data-target="app-info">
                <img src="Help Icon.png" class="menu-icon" style="width: 20px; vertical-align: middle; margin-right: 10px;"> About This App
            </li>
            <li class="help-option" data-target="booking-guide">
                <img src="Help Icon.png" class="menu-icon" style="width: 20px; vertical-align: middle; margin-right: 10px;"> Booking Guide
            </li>
        </ul>

        <div id="help-content" style="margin-top: 20px;">
            <p>Select an option above to see details.</p>
        </div>

        <div class="back-button-container">
            <a href="profile.jsp" class="back-btn">Back</a>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const helpOptions = document.querySelectorAll(".help-option");
            const helpContent = document.getElementById("help-content");

            if (helpContent) {
                const helpData = {
                    "faq": `
                        <div class="help-section">
                            <h3>Frequently Asked Questions</h3>
                            <div class="faq-item">
                                <h4>How do I book an appointment?</h4>
                                <p>Navigate to the 'All Doctors' section, select your preferred doctor, date, and time slot, then confirm your booking.</p>
                            </div>
                            <div class="faq-item">
                                <h4>Can I reschedule my appointment?</h4>
                                <p>Yes, go to 'Appointments', select the appointment you wish to change, and choose 'Reschedule'.</p>
                            </div>
                            <div class="faq-item">
                                <h4>What if I need urgent care?</h4>
                                <p>For emergencies, please call our emergency line at +254 748 234 887 or visit our facility at Egerton, Njoro opposite Egerton university  Main Campus.</p>
                            </div>
                            <div class="faq-item">
                                <h4>How do I cancel an appointment?</h4>
                                <p>In 'Appointments', select the appointment and click 'Cancel'. Please note our 48-hour cancellation policy.</p>
                            </div>
                        </div>
                    `,
                    "contact-support": `
                        <div class="help-section">
                            <h3>Hospital Support Channels</h3>
                            <div class="contact-method">
                                <h4>General Inquiries</h4>
                                <p>Main Line: +254 748 234 887</p>
                                <p>Email: info@tipapesgroup.co.ke</p>
                            </div>
                            <div class="contact-method">
                                <h4>Technical Support</h4>
                                <p>Support Line: +254 748 234 887</p>
                                <p>Email: support@tipapesgroup.co.ke</p>
                            </div>
                            <div class="contact-method">
                                <h4>Emergency Contacts</h4>
                                <p>Emergency: +254 748 234 887</p>
                                <p>Emergency Ward: Ground Floor, Wing A</p>
                            </div>
                        </div>
                    `,
                    "app-info": `
                        <div class="help-section">
                            <h3>About Our Hospital Booking System</h3>
                            <p>This digital platform is designed to streamline patient care and appointment management at Hospitals.</p>
                            <h4>Key Features:</h4>
                            <ul>
                                <li>Instant appointment confirmation</li>
                                <li>User history tracking</li>
                                <li>Appointments management</li>
                                <li>Secure patient portal</li>
                            </ul>
                            <h4>Our Commitment:</h4>
                            <p>We prioritize patient privacy and data security, complying with all healthcare regulations and using encrypted connections for all transactions.</p>
                            <div class="system-info">
                                <p><strong>Version:</strong> 2.4.1</p>
                                <p><strong>Last Updated:</strong> April 2025</p>
                            </div>
                        </div>
                    `,
                    "booking-guide": `
                        <div class="help-section">
                            <h3>Step-by-Step Booking Guide</h3>
                            <ol>
                                <li>Log in to your patient account/portal</li>
                                <li>Select 'All Doctors'</li>
                                <li>Choose Category (e.g., Cardiology, Pediatrics)</li>
                                <li>Select preferred doctor</li>
                                <li>Pick available date and time slot</li>
                                <li>Review and submit booking</li>
                            </ol>
                            <p><em>Note:</em> Please arrive 15 minutes before your scheduled time.</p>
                        </div>
                    `
                };

                helpOptions.forEach(option => {
                    option.addEventListener("click", () => {
                        const target = option.getAttribute("data-target");
                        helpContent.innerHTML = helpData[target] || "<p>Select an option above to see details.</p>";
                    });
                });
            }
        });
    </script>

</body>
</html>
