import { createAnimation, iosTransitionAnimation, isPlatform } from '@ionic/react';
import type { AnimationBuilder } from '@ionic/core/components';
import { createBrowserHistory } from 'history';

const isIosSafariNavigation = isPlatform('ios') && isPlatform('mobileweb');

export const appHistory = createBrowserHistory({
  basename: import.meta.env.BASE_URL,
});

let pendingProgrammaticPop = false;
let suppressNextBrowserPopAnimation = false;

const originalGo = appHistory.go.bind(appHistory);
const originalGoBack = appHistory.goBack.bind(appHistory);

appHistory.go = (delta: number) => {
  pendingProgrammaticPop = true;
  originalGo(delta);
};

appHistory.goBack = () => {
  pendingProgrammaticPop = true;
  originalGoBack();
};

appHistory.listen((_location, action) => {
  if (action !== 'POP') {
    pendingProgrammaticPop = false;
    return;
  }

  suppressNextBrowserPopAnimation = isIosSafariNavigation && !pendingProgrammaticPop;
  pendingProgrammaticPop = false;
});

export const safariSafeRouteAnimation: AnimationBuilder = (baseEl, opts) => {
  if (suppressNextBrowserPopAnimation) {
    suppressNextBrowserPopAnimation = false;
    return createAnimation();
  }

  return iosTransitionAnimation(baseEl, opts);
};
