export default {
  shouldRender(args, component) {
    const current = component.currentUser;
    return current && (current.id === args.model.get("id") || current.staff);
  },
};
