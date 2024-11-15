
# Workflow Overview:

## sequence diagram :



![Sequence workflow Diagram](https://nathabee.de/freebus/freebusSeqDiagReservation.png) 

- Sequence Diagram Structure
- User initiates the reservation.

- Interaction: User -> Frontend Application (Select route & date)
- Frontend Application sends request to Backend.

- Interaction: Frontend Application -> Backend (Check availability)
- Backend checks Database for availability.

- Interaction: Backend -> Database (Query available seats)
- Interaction: Database -> Backend (Return availability status)
- Backend responds to Frontend.

- If seats available:
- Interaction: Backend -> Frontend Application (Seats available, confirm details)
- If no seats available:
- Interaction: Backend -> Frontend Application (Seats unavailable)
- User confirms the reservation.

- Interaction: User -> Frontend Application (Confirm reservation)
- Frontend Application sends final confirmation to Backend.

- Interaction: Frontend Application -> Backend (Confirm reservation)
- Backend saves reservation in Database.

- Interaction: Backend -> Database (Save reservation details)
- Backend triggers Notification System to inform User.

- Interaction: Backend -> Notification System (Send reservation confirmation)
- Notification System sends confirmation to User.

- Interaction: Notification System -> User (Confirmation of reservation)
- Backend sends success response to Frontend Application.

- Interaction: Backend -> Frontend Application (Reservation successful)
- Frontend Application displays confirmation to User.

- Interaction: Frontend Application -> User (Reservation confirmed)

## Workflow :

### User Registration and Authentication:
- **Authentication** ensures secure access to the booking system.
- **Django JWT** is used for the authentication process.
- **Roles** are assigned within the Django admin console. A user can have one of three roles: **supervisor**, **administrator**, or **booking privilege**.
- Any user can **register for an account**, which initially puts them in a **pending mode** that does not grant booking privileges. The user must fill out a form during registration.
- In Django, we use a **custom user model** to store user contact data, including address, telephone, age, disability flag, and disability description.
- **Supervisors** validate user data. They can also modify user details or create new users.

### Route Management:
- The **Route Model** defines the list of different activities (e.g., trips to city X, supermarket, Christmas Market, etc.). Each route is linked to a maximum number of places on the bus.
- There are also restrictions on the number of **rolators** or **wheelchairs** that can be transported per route.

### Calendar Management:
- The **Calendar Model** defines which routes are planned for which day.
- Routes can be scheduled for **weekly** or **monthly** trips. Each calendar entry is linked to a specific route and contains information on the number of available seats.
- The calendar is also linked to **booking entries**, allowing users to reserve seats for a specific route and date.

### Booking Process:
- Users access the **booking page** to select a route and a date from the calendar.
- Users confirm their selection to finalize the booking.

### Ticket Generation:
- Upon successful booking, users receive a **digital ticket** with journey details and seat information.
- Tickets can be viewed in the **ticket history** menu.

### User Dashboard:
- Users have access to a **dashboard** where they can manage bookings, view past trips, and update personal information.

### Admin Management:
- **Admins** oversee the entire system, managing bus routes, the calendar, seat availability, user accounts, and roles.

### Supervision Management:
- **Supervisors** oversee the booking system, verify booked routes, manage routes and calendar entries, and oversee user personal information.


## sequence diagram :

 