<!-- TOC -->
  - [MODELE:](#modele)
    - [User Model:](#user-model)
    - [Route Model](#route-model)
    - [Calendar Model](#calendar-model)
    - [Reservation Model](#reservation-model)
    - [Ticket Model](#ticket-model)
<!-- TOC END -->
 

## MODELE:


### User Model:
 

The **User Model** will be implemented as a **custom user model** in Django to allow flexibility for storing additional user data beyond the standard fields. This will include:

- **Fields**:

  - `username`: The user's unique identifier.
  - `email`: A required field for registration and communication.
  - `password`: Stored securely using Django's built-in hashing mechanism.
  - `firstname`  : Personal information to address users.
  - `lastname`: Personal information to address users.
  - `streetname`: Personal information to address users.
  - `streetno`: Personal information to address users.
  - `note1`: (optional) Personal information to address users.
  - `note2`: (optional) Personal information to address users.
  - `streetno`: Personal information to address users.
  - `city`: To ensure eligibility for service access (e.g., validation for specific cities).
  - `age`: To prioritize users and analyze usage.
  - `status`: cycle : p (pending) => a (approved) => d (deactived).
  - `disability`: disability description.
  - `isdisabled`: disability flog.

- **Custom Methods**:

  - `verify_user()`: Allows admins to mark a user as verified after reviewing their details.

- **Relationships**:

  - The User model will be linked to reservations via a **ForeignKey relationship**, allowing easy tracking of which users have reserved which trips.
  - The User model will be linked to roles via a **ForeignKey relationship**

### Route Model

The **Route Model** defines the list of available activities and trips. Each route includes:

- **Fields**:
  - `route_name`: A descriptive name for the route (e.g., 'Trip to City X', 'Supermarket Visit', 'Christmas Market').
  - `max_seats`: The maximum number of seats available on the bus for this route.
  - `max_rolators_or_wheelchairs`: Defines the number of rolators or wheelchairs that can be transported per route.

### Calendar Model

The **Calendar Model** defines which routes are scheduled on which days:

- **Fields**:

  - `date`: The specific date of the route.
  - `route`: A reference to the **Route Model**, establishing which route is scheduled.
  - `available_seats`: The number of seats still available for this route on this date.

- **Relationships**:

  - Each calendar entry is linked to a **Route** and many **Reservation** entries to keep track of who has reserved which seat.

### Reservation Model

The **Reservation Model** handles the user reservations for specific routes and dates:

- **Fields**:

  - `user`: A reference to the **User Model** representing the person making the reservation.
  - `calendar_entry`: A reference to the **Calendar Model** representing the specific route and date.
  - `number_of_seats_reserved`: The number of seats reserved by the user.

- **Relationships**:

  - Linked to the **User** and **Calendar** models to manage reservation data and track availability.

### Ticket Model

The **Ticket Model** stores information about generated tickets:

- **Fields**:
  - `reservation`: A reference to the **Reservation Model** that the ticket is associated with.
  - `ticket_details`: Contains journey details, seat information, and other relevant information.
  - `issued_at`: The timestamp when the ticket was generated.

This high-level model specification outlines the key relationships and fields required to effectively manage the reservation and ticketing process for the Citizen Bus project.

