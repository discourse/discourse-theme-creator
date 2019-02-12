export default {
  shouldRender(args) {
    const current = Discourse.User.current();
    return (
      (current && current.get("id") === args.model.get("id")) || current.staff
    );
  }
};
