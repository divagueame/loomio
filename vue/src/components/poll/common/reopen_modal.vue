<script lang="js">
import Records from '@/shared/services/records';
import Flash   from '@/shared/services/flash';
import { addDays } from 'date-fns';

export default {
  props: {
    poll: Object,
    close: Function
  },

  created() {
    this.poll.closingAt = addDays(new Date, 7);
  },

  methods: {
    submit() {
      this.poll.reopen().then(() => {
        this.poll.processing = false;
        Flash.success("poll_common_reopen_form.success", {poll_type: this.poll.translatedPollType()});
        this.close();
      });
    }
  },
  data() {
    return {isDisabled: false};
  }
}
</script>

<template lang="pug">
v-card.poll-common-reopen-modal
  submit-overlay(:value='poll.processing')
  v-card-title
    h1.headline(tabindex="-1" v-t="{path: 'poll_common_reopen_form.title', args: {poll_type: poll.translatedPollType()}}")
    v-spacer
    dismiss-modal-button
  v-card-text.poll-common-reopen-form
    span.text--secondary(v-t="{path: 'poll_common_reopen_form.helptext', args: {poll_type: poll.translatedPollType()}}")
    poll-common-closing-at-field(:poll='poll')
  v-card-actions
    v-spacer
    v-btn.poll-common-reopen-form__submit(color="primary" @click='submit' :loading="poll.processing")
      span(v-t="'common.action.reopen'")
</template>
