require('intersection-observer')

fromEntries = require('object.fromentries');
fromEntries.shim() unless Object.fromEntries

matchAll = require('string.prototype.matchall')
matchAll.shim()

import 'array-flat-polyfill';

import Vue from 'vue'
import AppConfig from '@/shared/services/app_config'
import vuetify from '@/vuetify'
import router from '@/routes.coffee'
import i18n from '@/i18n.coffee'
import app from '@/app.vue'
import marked from '@/marked'
import '@/observe_visibility'
import './removeServiceWorker'
import { pick } from 'lodash'
import * as Sentry from '@sentry/browser'
import VueClipboard from 'vue-clipboard2'
import WatchRecords from '@/mixins/watch_records'
import CloseModal from '@/mixins/close_modal'
import UrlFor from '@/mixins/url_for'
import FormatDate from '@/mixins/format_date'
import Vue2TouchEvents from 'vue2-touch-events'

Vue.use(Vue2TouchEvents)

Vue.mixin(CloseModal)
Vue.mixin(WatchRecords)
Vue.mixin(UrlFor)
Vue.use(VueClipboard)
Vue.mixin(FormatDate)

Vue.config.productionTip = false

import boot from '@/shared/helpers/boot'
import Session from '@/shared/services/session'

boot (data) ->
  Session.apply(data)

  if AppConfig.plausable_src
    node = document.createElement('script');
    node.setAttribute('src', AppConfig.plausable_src);
    node.setAttribute('data-domain', AppConfig.plausable_site);
    node.setAttribute('defer','');
    document.head.appendChild(node);
    
  if AppConfig.sentry_dsn
    Sentry.configureScope (scope) ->
      scope.setUser pick(Session.user(), ['id', 'name', 'email', 'username'])

  new Vue(
    render: (h) -> h(app)
    router: router
    vuetify: vuetify
    i18n: i18n
  ).$mount('#app')
