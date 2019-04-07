import HomePage from './home-page-model';

const host = process.env.VUEPRESS_HOST;

fixture('Home Page').page(`http://${host}:8080`);

const homePage = new HomePage();

test('Get Started button goes to documentation landing page', async (t): Promise<void> => {
  // given

  // when
  await homePage.getStarted();

  // then
  const location = await t.eval((): Location => window.location);
  await t.expect(location.pathname).eql('/docs/');
});
