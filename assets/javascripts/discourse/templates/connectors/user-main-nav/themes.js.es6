export default {
  shouldRender(args) {
    return Discourse.User.current().get('id') === args.model.get('id');
  }
};