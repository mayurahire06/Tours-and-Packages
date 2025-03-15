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
			console.log(selectedMethod)
            openModal(modals[selectedMethod]);
        });

        // Close modal
        document.querySelectorAll('.close').forEach(closeBtn => {
            closeBtn.addEventListener('click', () => {
                closeModal(closeBtn.closest('.modal'));
            });
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
                        <input type="text" id="phone" value="9876543210" required>
                        <label for="password">Password</label>
                        <input type="password" id="password" value="1234" required>
                    `;
                    break;
                case 'phonepe':
                    walletFields.innerHTML = `
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" value="9876543210" required>
                        <label for="pin">PIN</label>
                        <input type="password" id="pin" value="1234" required>
                    `;
                    break;
                case 'googlepay':
                    walletFields.innerHTML = `
                        <label for="email">Email</label>
                        <input type="email" id="email" value="mayur@gmail.com" required>
                        <label for="password">Password</label>
                        <input type="password" id="password" value="Password" required>
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

    });