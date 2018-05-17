export default function(){
    this.route('theme-share', {path: 'theme/:theme_key'});
    this.route('theme-share', {path: 'theme/:username/:slug'});
};
