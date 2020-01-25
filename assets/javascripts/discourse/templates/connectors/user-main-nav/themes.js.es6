export default {
  shouldRender(args) {
    const current = Discourse.User.current();
    return current && (current.id === args.model.get("id") || current.staff);
  }
};
