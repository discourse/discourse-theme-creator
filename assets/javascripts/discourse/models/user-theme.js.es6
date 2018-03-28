import Theme from 'admin/models/theme';
import { url } from 'discourse/lib/computed';

export default Theme.extend({
  FIELDS_IDS: [0, 1, 5],
  shareUrl: url('id', `${location.protocol}//${location.host}${Discourse.getURL('/user_themes/%@/view')}`),
});