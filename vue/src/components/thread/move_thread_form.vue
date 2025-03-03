<script lang="js">
import Session        from '@/shared/services/session';
import Records        from '@/shared/services/records';
import I18n           from '@/i18n';
import EventBus from '@/shared/services/event_bus';
import Flash from '@/shared/services/flash';
import { filter } from 'lodash-es';

export default {
  props: {
    discussion: Object
  },
  data() {
    return {
      targetGroup: null,
      availableGroups: []
    };
  },
  created() {
    this.updateTarget();
    this.watchRecords({
      collections: ['groups', 'memberships'],
      query: store => {
        this.availableGroups = filter(Session.user().groups(), group => group.id !== this.discussion.groupId);
      }
    });
  },
  methods: {
    submit() {
      this.discussion.move().then(data => {
        Flash.success('move_thread_form.messages.success', { name: this.discussion.group().name });
        const discussionKey = data.discussions[0].key;
        Records.discussions.findOrFetchById(discussionKey, {}, true).then(discussion => {
          EventBus.$emit('closeModal');
          this.$router.push(`/d/${discussionKey}`);
        });
      }).catch(() => true);
    },

    updateTarget() {
      return this.targetGroup = Records.groups.find(this.discussion.groupId);
    },

    moveThread() {
      if (this.discussion.private && this.targetGroup.privacyIsOpen()) {
        if (confirm(I18n.t('move_thread_form.confirm_change_to_private_thread', {groupName: this.targetGroup.name}))) { this.submit(); }
      } else {
        this.submit();
      }
    }
  }
};
</script>
<template lang="pug">
v-card.move-thread-form
  submit-overlay(:value='discussion.processing')
  v-card-title
    h1.headline(tabindex="-1" v-t="'move_thread_form.title'")
    v-spacer
    dismiss-modal-button
  v-card-text
    v-select#group-dropdown.move-thread-form__group-dropdown(v-model='discussion.groupId' :required='true' @change='updateTarget()' :items='availableGroups' item-value='id' item-text='fullName' :label="$t('move_thread_form.body')")
      template(v-slot:item='data')
        v-list-item-content.group-dropdown-item
          v-list-item-title.group-dropdown-item-group-name
            span {{ data.item.fullName }}
  v-card-actions
    v-spacer
    v-btn.move-thread-form__submit(color="primary" type='button' v-t="'move_thread_form.confirm'" @click='moveThread()')
</template>
