<script lang="js">
import EventBus from '@/shared/services/event_bus';
import PollCommonDirective from '@/components/poll/common/directive.vue';
import Flash   from '@/shared/services/flash';
import { sortBy } from 'lodash-es';

export default {
  props: {
    stance: Object
  },
  components: {
    PollCommonDirective
  },

  methods: {
    submit() {
      const actionName = !this.stance.castAt ? 'created' : 'updated';
      this.stance.save().then(() => {
        Flash.success(`poll_${this.stance.poll().pollType}_vote_form.stance_${actionName}`);
        EventBus.$emit('closeModal')
      }).catch(error => true);
    }
  }
};
</script>
<template lang="pug">
v-card.poll-common-edit-vote-modal
  submit-overlay(:value="stance.processing")
  v-card-title
    h1.headline
      span(v-if="!stance.castAt", v-t="'poll_common.have_your_say'")
      span(v-if="stance.castAt", v-t="'poll_common.change_your_response'")
    v-spacer
    dismiss-modal-button(:model="stance")

  v-sheet.pa-4
    poll-common-directive(name="vote-form" :stance="stance")
</template>
