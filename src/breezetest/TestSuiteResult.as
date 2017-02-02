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
	public class TestSuiteResult
	{
		public var className:String;

		public var testResults:Vector.<TestResult> = new Vector.<TestResult>();

		public var setupResult:TestResult;

		public var tearDownResult:TestResult;


		public function get passed():Boolean
		{
			return (totalFailedTests == 0) && (setupResult == null) && (tearDownResult == null);
		}


		public function get failedTests():Vector.<TestResult>
		{
			var failedTests:Vector.<TestResult> = new <TestResult>[];

			for each(var result:TestResult in testResults)
			{
				if(!result.passed)
				{
					failedTests.push(result);
				}
			}

			return failedTests;
		}


		public function get totalTests():int
		{
			return testResults.length;
		}


		public function get totalFailedTests():int
		{
			return failedTests.length;
		}
	}
}
