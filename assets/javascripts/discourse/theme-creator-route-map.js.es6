export default {
  resource: 'user',
  path: 'u/:username',
  map() {
    this.route('themes', function(){
      this.route('show', {path: '/:theme_id'});
    });
  }
};