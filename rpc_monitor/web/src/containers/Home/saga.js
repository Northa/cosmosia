import { delay, put, select, takeLatest } from 'redux-saga/effects';
import { makeSelectHome } from './selectors';
import { ACTION_MONITOR_START } from './constants';
import { actionUpdate } from './actions';
import fetch from 'node-fetch';

export function* monitorStartTask() {
  while (true) {
    try {
      const homeState = yield select(makeSelectHome());
      const { monitoring } = homeState;
      if (!monitoring) {
        break;
      }

      // console.log(JSON.stringify(window.location));
      /**
       * {"ancestorOrigins":{},"href":"http://localhost:3000/#/","origin":"http://localhost:3000","protocol":"http:","host":"localhost:3000","hostname":"localhost","port":"3000","pathname":"/","search":"","hash":"#/"}
       */
      const {protocol, host}  = window.location;
      const URL =  `${protocol}//${host}/status.json`;

      const status_res =  yield fetch(URL, {compress: false});
      const res_json = yield status_res.json();
      console.log(`res_json=${JSON.stringify(res_json)}`);

      yield put(actionUpdate('status', res_json));
    } catch (e) {
      console.log(e)
    } finally {
      yield delay(60000);
    }
  }
}

export default function* homeSaga() {
  yield takeLatest(ACTION_MONITOR_START, monitorStartTask);
}
