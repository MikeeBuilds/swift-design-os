# Data Model: TaskFlow

## Core Entities

### Task
Represents a single actionable item in TaskFlow. This is the central entity of the application.

**Properties:**
- `id`: Unique identifier (UUID)
- `title`: Task title (String, required, max 200 chars)
- `description`: Detailed notes and context (String, optional)
- `isCompleted`: Completion status (Bool, default false)
- `dueDate`: When the task is due (Date?, optional)
- `dueTime`: Specific time component for the due date (Date?, optional)
- `priority`: Urgency level (Enum: low, medium, high, urgent, default: medium)
- `isFlagged`: User has marked as important (Bool, default false)
- `createdAt`: Timestamp when task was created (Date)
- `completedAt`: Timestamp when task was completed (Date?, optional)
- `order`: Position for manual sorting (Int)
- `listId`: Reference to parent list (UUID, optional)
- `projectId`: Reference to parent project (UUID, optional)

**Purpose:** Core unit of work that users create, manage, and complete.

---

### TaskList
Represents a container for organizing related tasks (e.g., "Work", "Personal", "Shopping").

**Properties:**
- `id`: Unique identifier (UUID)
- `name`: List name (String, required, max 100 chars)
- `colorHex`: Color for UI representation (String, format: "#RRGGBB")
- `icon`: Emoji or SF Symbol (String, optional)
- `order`: Position in lists view (Int)
- `createdAt`: Timestamp when list was created (Date)
- `isArchived`: Whether list is hidden from main view (Bool)

**Purpose:** Organizes tasks into logical groups for better navigation and focus.

---

### Project
Represents a larger initiative or goal that contains multiple lists and tasks (e.g., "Website Redesign", "Learn Swift").

**Properties:**
- `id`: Unique identifier (UUID)
- `name`: Project name (String, required, max 100 chars)
- `description`: Project overview (String, optional)
- `colorHex`: Color for UI representation (String, format: "#RRGGBB")
- `dueDate`: Optional project deadline (Date?)
- `isArchived`: Whether project is hidden from main view (Bool)
- `createdAt`: Timestamp when project was created (Date)

**Purpose:** Groups related lists and tasks under a shared goal or initiative.

---

### Reminder
Represents a notification trigger for a task, supporting time-based and location-based alerts.

**Properties:**
- `id`: Unique identifier (UUID)
- `taskId`: Reference to parent task (UUID, required)
- `fireDate`: When reminder should trigger (Date, required for time-based)
- `repeatSchedule`: Repeat pattern (Enum: none, daily, weekly, monthly, yearly, custom)
- `type`: Reminder type (Enum: time, location)
- `locationType`: For location reminders (Enum: onArrive, onLeave)
- `latitude`: Location coordinate (Double?, optional)
- `longitude`: Location coordinate (Double?, optional)
- `radius`: Location radius in meters (Double?, optional)
- `isSnoozed`: Whether user snoozed this reminder (Bool)
- `snoozeUntil`: When snooze ends (Date?, optional)

**Purpose:** Ensures users never miss important tasks by delivering timely notifications.

---

### User
Represents the current app user and their preferences.

**Properties:**
- `id`: Unique identifier (UUID)
- `name`: Display name (String, optional)
- `email`: Email address (String, optional)
- `cloudKitIdentifier`: Apple CloudKit user ID (String, optional)
- `createdAt`: Account creation date (Date)
- `preferences`: User settings (JSON or separate entity)

**Purpose:** Stores user identity and syncs preferences across devices.

---

## Relationships

### Task → TaskList
**Relationship Type:** Many-to-One
**Direction:** A task belongs to exactly one list (optional)
**Explanation:** Tasks can be organized into lists for categorization. A list can contain many tasks. This relationship is optional because tasks can exist in the "Inbox" without being assigned to a list.

### Task → Project
**Relationship Type:** Many-to-One
**Direction:** A task belongs to exactly one project (optional)
**Explanation:** Tasks can be part of larger projects. A project contains many tasks through its lists. This is optional for tasks that don't fit into a project structure.

### Task → Reminder
**Relationship Type:** One-to-Many
**Direction:** A task can have many reminders
**Explanation:** Users may want multiple reminders for a single task (e.g., one week before, one day before, and one hour before the due date).

### TaskList → Project
**Relationship Type:** Many-to-One
**Direction:** A list belongs to exactly one project (optional)
**Explanation:** Lists can be organized under projects. A project contains multiple lists. This is optional because some lists may exist at the top level (e.g., "Personal", "Work").

### User → Task
**Relationship Type:** One-to-Many
**Direction:** A user owns many tasks
**Explanation:** In this version, TaskFlow is single-user. All tasks belong to the current user. This relationship may evolve to support sharing in future versions.

### User → TaskList
**Relationship Type:** One-to-Many
**Direction:** A user owns many lists
**Explanation:** All lists belong to the current user for organizing their personal tasks.

### User → Project
**Relationship Type:** One-to-Many
**Direction:** A user owns many projects
**Explanation:** All projects are owned and managed by the current user.

---

## Design Notes

### Why No "Tag" Entity?
TaskFlow uses lists and projects as the primary organization method rather than tags. This keeps the data model simpler and matches the mental model of "my work lists" vs "tag clouds." If tagging becomes a highly-requested feature, it can be added later without disrupting the core structure.

### Why Separate Reminder Entity?
Reminders have complex properties (repeat schedules, location data, snooze state) that would clutter the Task entity if embedded. Separating them also allows for multiple reminders per task, a feature requested by power users.

### UUID for All Identifiers
Using UUIDs instead of auto-incrementing integers ensures unique identifiers that work across devices without requiring coordination. This is critical for CloudKit synchronization.

### Optional Parent Relationships
Tasks, lists, and projects can exist without parents to support a flexible hierarchy. The "Inbox" concept works because tasks don't require a list. Similarly, lists can exist outside of projects for quick personal organization.

### CloudKit Schema Considerations
When implementing sync, CloudKit records will mirror these entities. The `cloudKitIdentifier` on the User entity will be used to track which user owns which data in the shared CloudKit database.
