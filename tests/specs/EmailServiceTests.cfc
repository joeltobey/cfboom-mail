/*
 * Copyright 2016-2017 the original author or authors and Joel Tobey <joeltobey@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author Joel Tobey
 */
component
  extends="coldbox.system.testing.BaseTestCase"
  appMapping="/root"
  displayname="Class EmailServiceTests"
  output="false"
{
  // this will run once after initialization and before setUp()
  public void function beforeTests() {
    super.beforeTests();
    variables['EmailService'] = getInstance( "EmailService@cfboomMail" );
  }

  // this will run once after all tests have been run
  public void function afterTests() {
    structDelete( variables, "EmailService" );
    super.afterTests();
  }

  /**
   * @Test
   */
  public void function testGetEmailDomain() {
    assertEqualsCase( "mycompany.com", EmailService.getEmailDomain( "john.doe@mycompany.com" ) );
    assertEqualsCase( "myCompany.com", EmailService.getEmailDomain( "john.doe@myCompany.com" ) );
    assertEqualsCase( "", EmailService.getEmailDomain( "john.doe[at]myCompany.com" ) );
  }

}