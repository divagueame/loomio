<script lang="js">
import Flash from '@/shared/services/flash';
import EventBus from '@/shared/services/event_bus';

export default {
  props: {
    event: Object
  },

  data() {
    return {
      title: null,
      loading: false
    };
  },

  mounted() {
    this.title = (window.getSelection() && window.getSelection().toString()) || this.event.pinnedTitle || this.event.suggestedTitle();
    this.$nextTick(() => this.$refs.focus.focus());
  },

  methods: {
    submit() {
      this.loading = true;
      this.event.pin(this.title).then(() => {
        Flash.success('activity_card.event_pinned');
        EventBus.$emit('closeModal');
      });
    }
  }
};

</script>
<template lang="pug">
v-card.pin-event-form
  v-card-title
    span(v-t="'pin_event_form.title'")
    v-spacer
    dismiss-modal-button(aria-hidden='true')
  v-card-text
    v-form(@submit.prevent="submit()")
      v-text-field(:disabled="loading" ref="focus" v-model="title" :label="$t('pin_event_form.title_label')")
    //- p.caption(v-t="'pin_event_form.hint'")
  v-card-actions
    v-spacer
    v-btn(color="primary" @click="submit()" :loading="loading" v-t="'common.action.save'")
</template>
