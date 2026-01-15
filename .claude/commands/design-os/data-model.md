# Define Your Data Model

Let's design the core data model for your product. This is about identifying the key entities (the "nouns" of your system) and how they relate to each other.

## Step 1: Identify Core Entities

First, let's identify the main objects in your system.

**What are the primary entities in your product?**

For example:
- A todo app might have: `User`, `TodoList`, `TodoItem`, `Tag`
- An e-commerce app might have: `Product`, `Category`, `Cart`, `Order`, `User`
- A social app might have: `User`, `Post`, `Comment`, `Like`, `Follow`

List your core entities below, one per line:

```
[Your entities here]
```

---

## Step 2: Describe Each Entity

Now, let's add brief descriptions for each entity to understand what they represent.

For each entity, describe:
- What it represents in your domain
- Its purpose in the system
- Any important characteristics

```
[Entity 1]: [Description]

[Entity 2]: [Description]

[Entity 3]: [Description]
```

---

## Step 3: Define Relationships

Let's map out how these entities connect to each other.

Consider relationship types:
- **One-to-One** (e.g., User ↔ Profile)
- **One-to-Many** (e.g., User → has many Posts)
- **Many-to-Many** (e.g., Post ↔ Tags)

For each relationship, describe:
- Which entities are connected
- The relationship type
- A brief explanation of why they're related

```
[Entity A] → [Entity B]: [Relationship type] - [Explanation]

[Entity B] → [Entity C]: [Relationship type] - [Explanation]
```

---

## Step 4: Refine and Validate

**Questions to consider:**

1. Are there any entities you're missing?
2. Are any entities doing too much (could be split)?
3. Are the relationships clear and necessary?
4. Will this model support your core features?

**What changes would you like to make?**

---

## Implementation Notes

When you're satisfied with your data model, I'll save it to `product/data-model/data-model.md` for reference during implementation.

**Ready to proceed?** Share your answers above, and I'll help you refine the model and save it.

---

## Tips

- Start simple: focus on entities needed for your MVP features
- Avoid premature optimization: leave room for the model to evolve
- Think in Swift terms: consider how these will become structs/classes
- Relationships will map to properties and collections in Swift
- Keep implementation details separate—this is about your domain model
