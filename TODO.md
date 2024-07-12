# TODO
- [x] Finish menu specs
- Make a way to display a small window that can take input for a confirmation dialog
  - [x] Confirm class
  - [x] Init with message
  - [x] Toggle input with tab, accept with enter
  - [x] Always returns a boolean input
  - [ ] Resize handling doesn't work when the confirm is up
  - [x] Look for TODOs
  - [x] Specs
- Open an email
  - [x] Rename Mail class to Mailbox
  - [x] Display an email
  - [x] Need to be able to scroll up and down
  - [ ] scrollbar would be ideal, just to indicate there is more
- [x] Fix the email ordering
- [ ] Put images into temp files where they can be opened in a browser?!
- [x] Refactor to make each section of the UI a different curses window. They could be placed
  next to each other visually, and each one could be registered in a list. Then I could iterate over
  each when it was time to redraw, they they could all keep their own redraw logic to themselves.
  Ideally they can all have their own key listening logic too... maybe.
- [ ] I want to have a concept of having focus on either the email list or the email display, switched with tab
- [ ] Make a common component class that all the components inherit from. Put common stuff in it I guess.

