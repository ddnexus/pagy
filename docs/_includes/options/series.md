`slots: 9`
: Override the default number of page `:slots` used for the navigation bar.
  - `slots < 7` fills the slots with contiguous pages around the current one.
  - `slots >= 7` reserves the first and last slots for the first and last pages, separated from the rest by a `...` (`:gap`) slot when needed.
  - Prefer odd numbers of slots, which place the current page in the central slot.

`compact: true`
: Fill all the slots with contiguous pages, regardless of the number of slots.
