import { Selector, t } from 'testcafe';

export default class HomePage {
  private getStartedButton: Selector;

  public constructor() {
    this.getStartedButton = Selector('a.nav-link.action-button');
  }

  public async getStarted(): Promise<void> {
    await t.click(this.getStartedButton);
  }
}
