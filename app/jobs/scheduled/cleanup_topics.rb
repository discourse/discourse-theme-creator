module Jobs
  class CleanupTopics < Jobs::Scheduled
    every 30.minutes

    def execute(_args)
      Topic.where(category_id: SiteSetting.theme_creator_junk_category_ids.split('|'))
           .where('bumped_at < ?', 1.week.ago)
           .where(pinned_at: nil)
           .each do |topic|
        PostDestroyer.new(Discourse.system_user, topic.first_post).destroy
      end
    end
  end
end
