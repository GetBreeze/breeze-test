/*
 * MIT License
 *
 * Copyright (c) 2017 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

package breezetest
{
	public class BreezeTestResult
	{
		public var testSuiteResults:Vector.<TestSuiteResult> = new Vector.<TestSuiteResult>();


		public function get passed():Boolean
		{
			for each(var result:TestSuiteResult in testSuiteResults)
			{
				if(!result.passed)
				{
					return false;
				}
			}

			return true;
		}


		public function get totalTestSuites():int
		{
			return testSuiteResults.length;
		}


		public function get totalFailedTestSuites():int
		{
			return failedTestSuites.length;
		}


		public function get failedTestSuites():Vector.<TestSuiteResult>
		{
			var failedTestSuites:Vector.<TestSuiteResult> = new <TestSuiteResult>[];

			for each(var result:TestSuiteResult in testSuiteResults)
			{
				if(!result.passed)
				{
					failedTestSuites.push(result);
				}
			}

			return failedTestSuites;
		}


		public function get totalTests():int
		{
			var tests:int = 0;

			for each(var result:TestSuiteResult in testSuiteResults)
			{
				tests += result.totalTests;
			}

			return tests;
		}


		public function get totalFailedTests():int
		{
			var failedTests:int = 0;
			for each(var result:TestSuiteResult in testSuiteResults)
			{
				failedTests += result.failedTests.length;
			}
			return failedTests;
		}

	}
}
