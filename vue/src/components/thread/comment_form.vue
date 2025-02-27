<script lang="js">
import Session        from '@/shared/services/session';
import Records        from '@/shared/services/records';
import EventBus       from '@/shared/services/event_bus';
import AbilityService from '@/shared/services/ability_service';
import Flash  from '@/shared/services/flash';
import { last } from 'lodash-es';

export default {
  props: {
    comment: Object,
    autofocus: Boolean
  },

  data() {
    return {
      actor: Session.user(),
      canSubmit: true,
      shouldReset: false
    };
  },

  computed: {
    placeholder() {
      if (this.comment.parentId) {
        return this.$t('comment_form.in_reply_to', {name: this.comment.parent().author().nameOrUsername()});
      } else {
        return this.$t('comment_form.aria_label');
      }
    }
  },

  methods: {
    handleIsUploading(val) {
      return this.canSubmit = !val;
    },

    submit() {
      this.comment.save().then(() => {
        this.$emit('comment-submitted');
        this.shouldReset = !this.shouldReset;
        const flashMessage = !this.comment.isNew() ?
                        'comment_form.messages.updated'
                      : this.comment.isReply() ?
                        'comment_form.messages.replied'
                      :
                        'comment_form.messages.created';
        Flash.success(flashMessage, {name: this.comment.isReply() ? this.comment.parent().author().nameOrUsername() : undefined});
      }).catch(err => {
        Flash.error('common.something_went_wrong');
      });
    }
  }
};

</script>

<template lang="pug">
v-layout.comment-form
  .thread-item__avatar.mr-3
    user-avatar(
      :user='comment.author() || actor'
      :size='comment.parentId ? 28 : 36'
    )
  form.thread-item__body.comment-form__body(v-on:submit.prevent='submit()' @keyup.ctrl.enter="submit()" @keydown.meta.enter.stop.capture="submit()")
    submit-overlay(:value='comment.processing')
    lmo-textarea.ml-n1(
      :model='comment'
      @is-uploading="handleIsUploading"
      field="body"
      :placeholder="placeholder"
      :autofocus="autofocus"
      :shouldReset="shouldReset")
      template(v-slot:actions)
        v-btn.comment-form__submit-button(
          :disabled="!canSubmit"
          color="primary"
          type='submit'
          v-t="comment.isNew() ? 'comment_form.post_comment' : 'common.action.save' ")
    v-alert(color="error" v-if="comment.saveFailed")
      span(v-t="'common.something_went_wrong'")
      space
      span(v-t="'common.please_try_again'")
</template>

<style lang="sass">
.comment-form__body
  flex-grow: 1
</style>
