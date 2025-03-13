// Toggle accordion sections
        document.querySelectorAll('.accordion-header').forEach(header => {
            header.addEventListener('click', () => {
                const accordion = header.parentElement;
                accordion.classList.toggle('active');
            });
        });
        
        // Select payment method
        document.querySelectorAll('.payment-option').forEach(option => {
            option.addEventListener('click', () => {
                // Clear previous selection
                document.querySelectorAll('.payment-option').forEach(opt => {
                    opt.classList.remove('selected');
                });
                
                // Select current option
                option.classList.add('selected');
                
                // Check the radio button
                const radio = option.querySelector('input[type="radio"]');
                radio.checked = true;
                
                // Update hidden input for form submission
                document.getElementById('selected-payment-method').value = radio.id;
            });
        });

    document.addEventListener('DOMContentLoaded', () => {
        const proceedBtn = document.getElementById('proceed-btn');
        const modals = {
            'credit-card': document.getElementById('credit-card-modal'),
            'upi': document.getElementById('upi-modal'),
            'net-banking': document.getElementById('net-banking-modal'),
            'wallet': document.getElementById('wallet-modal')
        };

        // Open modal when Proceed is clicked
        proceedBtn.addEventListener('click', () => {
            const selectedMethod = document.querySelector('input[name="payment-method"]:checked').id;
            openModal(modals[selectedMethod]);
        });

        // Close modal
        document.querySelectorAll('.close').forEach(closeBtn => {
            closeBtn.addEventListener('click', () => {
                closeModal(closeBtn.closest('.modal'));
            });
        });

        // Credit/Debit Card Form Validation
        document.getElementById('credit-card-form').addEventListener('submit', (e) => {
            e.preventDefault();
            const cardNumber = document.getElementById('card-number').value;
            const expiry = document.getElementById('expiry').value;
            const cvv = document.getElementById('cvv').value;
            const cardholderName = document.getElementById('cardholder-name').value;
            const error = document.getElementById('credit-card-error');

            if (!/^\d{13,19}$/.test(cardNumber)) {
                error.textContent = 'Card number must be 13-19 digits.';
                return;
            }
            if (!/^(0[1-9]|1[0-2])\/\d{4}$/.test(expiry) || !isFutureDate(expiry)) {
                error.textContent = 'Invalid or expired date (MM/YYYY).';
                return;
            }
            if (!/^\d{3,4}$/.test(cvv)) {
                error.textContent = 'CVV must be 3 or 4 digits.';
                return;
            }
            if (!cardholderName.trim()) {
                error.textContent = 'Cardholder name is required.';
                return;
            }
            error.textContent = '';
            alert('Credit/Debit Card details submitted successfully!');
            closeModal(modals['credit-card']);
        });

        // UPI Form Validation
        document.getElementById('upi-form').addEventListener('submit', (e) => {
            //e.preventDefault();
            const upiId = document.getElementById('upi-id').value;
            const upiPin = document.getElementById('upi-pin').value;
            const error = document.getElementById('upi-error');

            if (!/@/.test(upiId)) {
                error.textContent = 'UPI ID must contain "@" (e.g., example@upi).';
                return;
            }
            if (!/^\d{4,6}$/.test(upiPin)) {
                error.textContent = 'PIN must be 4-6 digits.';
                return;
            }
            error.textContent = '';
            //alert('UPI details submitted successfully!');
            closeModal(modals['upi']);
        });

        // Net Banking Form Validation
        document.getElementById('net-banking-form').addEventListener('submit', (e) => {
            e.preventDefault();
            const bankName = document.getElementById('bank-name').value;
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const error = document.getElementById('net-banking-error');

            if (!bankName) {
                error.textContent = 'Please select a bank.';
                return;
            }
            if (!username.trim() || !password.trim()) {
                error.textContent = 'All fields are required.';
                return;
            }
            error.textContent = '';
            alert('Net Banking details submitted successfully!');
            closeModal(modals['net-banking']);
        });

        // Wallet Form Handling
        const walletProvider = document.getElementById('wallet-provider');
        const walletFields = document.getElementById('wallet-fields');
        walletProvider.addEventListener('change', () => {
            walletFields.innerHTML = '';
            switch (walletProvider.value) {
                case 'paytm':
                    walletFields.innerHTML = `
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" placeholder="9876543210" required>
                        <label for="password">Password</label>
                        <input type="password" id="password" placeholder="Password" required>
                    `;
                    break;
                case 'phonepe':
                    walletFields.innerHTML = `
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" placeholder="9876543210" required>
                        <label for="pin">PIN</label>
                        <input type="password" id="pin" placeholder="****" required>
                    `;
                    break;
                case 'googlepay':
                    walletFields.innerHTML = `
                        <label for="email">Email</label>
                        <input type="email" id="email" placeholder="user@gmail.com" required>
                        <label for="password">Password</label>
                        <input type="password" id="password" placeholder="Password" required>
                    `;
                    break;
            }
        });

        document.getElementById('wallet-form').addEventListener('submit', (e) => {
            e.preventDefault();
            const provider = walletProvider.value;
            const error = document.getElementById('wallet-error');

            if (!provider) {
                error.textContent = 'Please select a wallet provider.';
                return;
            }

            if (provider === 'paytm' || provider === 'phonepe') {
                const phone = document.getElementById('phone').value;
                if (!/^\d{10}$/.test(phone)) {
                    error.textContent = 'Phone number must be 10 digits.';
                    return;
                }
            }
            if (provider === 'paytm' || provider === 'googlepay') {
                const password = document.getElementById('password').value;
                if (!password.trim()) {
                    error.textContent = 'Password is required.';
                    return;
                }
            }
            if (provider === 'phonepe') {
                const pin = document.getElementById('pin').value;
                if (!/^\d{4}$/.test(pin)) {
                    error.textContent = 'PIN must be 4 digits.';
                    return;
                }
            }
            if (provider === 'googlepay') {
                const email = document.getElementById('email').value;
                if (!/@/.test(email)) {
                    error.textContent = 'Invalid email format.';
                    return;
                }
            }
            error.textContent = '';
            alert('Wallet details submitted successfully!');
            closeModal(modals['wallet']);
        });

        // Helper Functions
        function openModal(modal) {
            modal.style.display = 'block';
        }

        function closeModal(modal) {
            modal.style.display = 'none';
            modal.querySelector('.error').textContent = '';
        }

        function isFutureDate(expiry) {
            const [month, year] = expiry.split('/').map(Number);
            const today = new Date();
            const currentYear = today.getFullYear();
            const currentMonth = today.getMonth() + 1;
            return year > currentYear || (year === currentYear && month >= currentMonth);
        }
    });