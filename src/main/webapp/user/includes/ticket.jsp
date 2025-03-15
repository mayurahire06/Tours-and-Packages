<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <title>Travel Ticket</title>
  <!-- MDBootstrap CSS -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.0/mdb.min.css" rel="stylesheet">
  <!-- Font Awesome -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <!-- Custom CSS -->
  <link href="ticket-styles.css" rel="stylesheet">
</head>
<body>
  <%-- Simulated JSP variables (in a real JSP, these would come from the server) --%>
  <c:set var="passenger" value="${ticket.passenger}" />
  <c:set var="flight" value="${ticket.flight}" />
  <c:set var="booking" value="${ticket.booking}" />

  <div class="container my-5">
    <div class="row justify-content-center">
      <div class="col-md-10">
        <!-- Ticket Container -->
        <div class="ticket-container">
          <!-- Ticket Header -->
          <div class="ticket-header">
            <div class="d-flex justify-content-between align-items-center">
              <div class="logo-container">
                <h2 class="mb-0">SkyWay</h2>
                <span class="tagline">Premium Airways</span>
              </div>
              <div class="ticket-type">
                <span class="badge bg-primary rounded-pill">BUSINESS CLASS</span>
              </div>
            </div>
          </div>
          
          <!-- Ticket Body -->
          <div class="ticket-body">
            <div class="row">
              <!-- Left Section - Flight Details -->
              <div class="col-md-8 pe-md-4">
                <div class="flight-info mb-4">
                  <div class="row">
                    <div class="col-5">
                      <div class="city">${flight.from.city}</div>
                      <div class="airport">${flight.from.airport}</div>
                      <div class="time">${flight.from.time}</div>
                      <div class="date">${flight.from.date}</div>
                    </div>
                    <div class="col-2 flight-path">
                      <div class="plane-icon">
                        <i class="fas fa-plane"></i>
                      </div>
                      <div class="flight-line"></div>
                    </div>
                    <div class="col-5 text-end">
                      <div class="city">${flight.to.city}</div>
                      <div class="airport">${flight.to.airport}</div>
                      <div class="time">${flight.to.time}</div>
                      <div class="date">${flight.to.date}</div>
                    </div>
                  </div>
                  <div class="flight-details mt-3">
                    <div class="row text-center">
                      <div class="col-4">
                        <div class="detail-label">FLIGHT</div>
                        <div class="detail-value">${flight.number}</div>
                      </div>
                      <div class="col-4">
                        <div class="detail-label">GATE</div>
                        <div class="detail-value">${flight.gate}</div>
                      </div>
                      <div class="col-4">
                        <div class="detail-label">SEAT</div>
                        <div class="detail-value">${flight.seat}</div>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- Passenger Info -->
                <div class="passenger-info mb-4">
                  <h5 class="section-title">PASSENGER INFORMATION</h5>
                  <div class="row">
                    <div class="col-md-6">
                      <div class="info-label">NAME</div>
                      <div class="info-value">${passenger.name}</div>
                    </div>
                    <div class="col-md-3">
                      <div class="info-label">AGE</div>
                      <div class="info-value">${passenger.age}</div>
                    </div>
                    <div class="col-md-3">
                      <div class="info-label">GENDER</div>
                      <div class="info-value">${passenger.gender}</div>
                    </div>
                  </div>
                </div>
                
                <!-- Additional Info -->
                <div class="additional-info">
                  <div class="row">
                    <div class="col-md-6">
                      <div class="info-label">BOOKING REF</div>
                      <div class="info-value">${booking.reference}</div>
                    </div>
                    <div class="col-md-6">
                      <div class="info-label">ISSUED</div>
                      <div class="info-value">${booking.issued}</div>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Right Section - Barcode and QR -->
              <div class="col-md-4 ps-md-4 border-start">
                <div class="boarding-section text-center">
                  <h5 class="boarding-title">BOARDING PASS</h5>
                  <div class="qr-code mb-3" id="qrcode"></div>
                  <div class="boarding-info">
                    <div class="info-label">BOARDING TIME</div>
                    <div class="info-value">${flight.boardingTime}</div>
                    <div class="info-label mt-2">TERMINAL</div>
                    <div class="info-value">${flight.terminal}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Ticket Footer -->
          <div class="ticket-footer">
            <div class="barcode-container text-center">
              <div id="barcode"></div>
              <div class="barcode-text">${flight.number} ${flight.from.city}${flight.to.city}${passenger.name}${flight.seat}</div>
            </div>
            <div class="footer-note text-center mt-2">
              <small>This ticket is non-refundable and non-transferable. Please arrive at the airport at least 2 hours before departure.</small>
            </div>
          </div>
          
          <!-- Tear Line -->
          <div class="tear-line">
            <div class="tear-circles"></div>
          </div>
          
          <!-- Ticket Stub -->
          <div class="ticket-stub">
            <div class="row">
              <div class="col-6">
                <div class="stub-label">FLIGHT</div>
                <div class="stub-value">${flight.number}</div>
                <div class="stub-label">PASSENGER</div>
                <div class="stub-value">${passenger.name}</div>
              </div>
              <div class="col-6 text-end">
                <div class="stub-label">FROM - TO</div>
                <div class="stub-value">${flight.from.airport.substring(flight.from.airport.lastIndexOf('(') + 1, flight.from.airport.lastIndexOf(')'))} - ${flight.to.airport.substring(flight.to.airport.lastIndexOf('(') + 1, flight.to.airport.lastIndexOf(')'))}</div>
                <div class="stub-label">SEAT</div>
                <div class="stub-value">${flight.seat}</div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Print Button -->
        <div class="text-center mt-4">
          <button class="btn btn-primary" id="print-ticket">
            <i class="fas fa-print me-2"></i> Print Ticket
          </button>
          <button class="btn btn-success ms-2" id="download-ticket">
            <i class="fas fa-download me-2"></i> Download PDF
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- MDBootstrap JS -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.0/mdb.min.js"></script>
  <!-- QR Code Library -->
  <script src="https://cdn.jsdelivr.net/npm/qrcode-generator@1.4.4/qrcode.min.js"></script>
  <!-- JsBarcode Library -->
  <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>
  <!-- Custom JS -->
  <script src="ticket-script.js"></script>
</body>
</html>