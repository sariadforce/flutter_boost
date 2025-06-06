/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 Alibaba Group
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import hilog from '@ohos.hilog';
import { FlutterBoostEntry } from 'flutter_boost';
import { FlutterPage, FlutterView } from '@ohos/flutter_ohos';
import { RouterOptions } from '../router/RouterModule';

const TAG: string = "FlutterUIPage";
@Component
export struct FlutterUIPage {
  private flutterEntry: FlutterBoostEntry | null = null;
  private flutterView: FlutterView | null = null;
  private routeStack: NavPathStack | null = null;
  @Prop xComponentType: XComponentType = XComponentType.SURFACE;
  @Prop routerOptions: RouterOptions;

  onPopCallback(result: Record<string, Object>): void {
    hilog.info(0x0000, TAG, "onPopCallback===");
    this.routeStack?.pop(result);
  }

  async aboutToAppear() {
    hilog.info(0x0000, TAG, "aboutToAppear===");
    this.flutterEntry = new FlutterBoostEntry(getContext(this), this.routerOptions, false, this.onPopCallback);
    await this.flutterEntry.aboutToAppear();
    // The |aboutToAppear| method is called first,
    // followed by the |getFlutterView| method.
    this.flutterView = this.flutterEntry.getFlutterView();
  }

  aboutToDisappear() {
    hilog.info(0x0000, TAG, "aboutToDisappear===");
    this.flutterEntry?.aboutToDisappear()
  }

  build() {
    NavDestination() {
      FlutterPage({
        viewId: this.flutterView!.getId(),
        xComponentType: this.xComponentType
      })
    }
    .hideTitleBar(true)
    .onBackPressed(() => {
      hilog.info(0x0000, TAG, "onBackPressed===");
      return this.flutterEntry!.onBackPressed();
    })
    .onAppear(() => {
      hilog.info(0x0000, TAG, "onAppear===");
    })
    .onDisAppear(() => {
      hilog.info(0x0000, TAG, "onDisAppear===");
    })
    .onShown(() => {
      hilog.info(0x0000, TAG, "onShown===");
      this.flutterEntry?.onShown();
    })
    .onHidden(() => {
      hilog.info(0x0000, TAG, "onHidden===");
      this.flutterEntry?.onHidden();
    })
    .onReady((ctx: NavDestinationContext) => {
      try {
        hilog.info(0x0000, TAG, "onReady===");
        this.routeStack = ctx.pathStack;
        this.flutterEntry?.onReady(ctx.pathStack);
      } catch (e) {
        hilog.error(0x0000, TAG, `onReady catch exception: ${JSON.stringify(e)}`);
      }
    })
  }
}
