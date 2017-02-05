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

package tests.async
{
	import breezetest.Assert;
	import breezetest.async.Async;

	import flash.utils.setTimeout;
	
	public class TestPublicAsync
	{

		public var currentAsync:Async;


		public function setupClass(async:Async):void
		{
			Assert.isNotNull(currentAsync, 'Current Async object must be assigned to the public variable.');
			Assert.same(currentAsync, async);

			setTimeout(asyncOperationComplete, 100);
		}


		public function setup(async:Async):void
		{
			Assert.isNotNull(currentAsync, 'Current Async object must be assigned to the public variable.');
			Assert.same(currentAsync, async);

			setTimeout(asyncOperationComplete, 100);
		}


		public function tearDown(async:Async):void
		{
			Assert.isNotNull(currentAsync, 'Current Async object must be assigned to the public variable.');
			Assert.same(currentAsync, async);

			setTimeout(asyncOperationComplete, 100);
		}


		public function tearDownClass(async:Async):void
		{
			Assert.isNotNull(currentAsync, 'Current Async object must be assigned to the public variable.');
			Assert.same(currentAsync, async);

			setTimeout(asyncOperationComplete, 100);
		}


		public function testAsync(async:Async):void
		{
			Assert.isNotNull(currentAsync, 'Current Async object must be assigned to the public variable.');
			Assert.same(currentAsync, async);

			setTimeout(asyncOperationComplete, 100);
		}


		public function testSync():void
		{
			Assert.isNull(currentAsync, 'Current Async object should be null during synchronous test.');
		}


		private function asyncOperationComplete():void
		{
			currentAsync.complete();
		}
		
	}
	
}
