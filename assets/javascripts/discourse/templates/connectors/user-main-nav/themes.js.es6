export default {
  shouldRender(args, component) {
    return Discourse.User.current().get('id') === args.model.get('id');
  }
}