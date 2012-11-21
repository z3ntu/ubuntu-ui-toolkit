/*
 * Copyright 2012 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtTest 1.0
import Ubuntu.Components 0.1

TestCase {
     name: "ProgressBarAPI"

     function test_indeterminate() {
         compare(progressBar.indeterminate,false,"is not set by default")
         var newIndeterminated = true
         progressBar.indeterminate = newIndeterminated
         compare(progressBar.indeterminate,newIndeterminated,"can set/get")
     }

     function test_maximumValue() {
         compare(progressBar.maximumValue,1.0,"is set to 1.0 by default")
         var newMaximumValue = 20.0
         progressBar.maximumValue = newMaximumValue
         compare(progressBar.maximumValue,newMaximumValue,"can set/get")
     }

     function test_minimumValue() {
         compare(progressBar.minimumValue,0,"is set to 0 by default")
         var newMinimumValue = -20.0
         progressBar.minimumValue = newMinimumValue
         compare(progressBar.minimumValue,newMinimumValue,"can set/get")
     }

     function test_value() {
         skip("https://bugs.launchpad.net/tavastia/+bug/1076764")
         compare(progressBar.value,0,"is set to 0 by default")
         var newValue = 5
         progressBar.value = newValue
         compare(progressBar.value,newValue,"can set/get")
     }

     ProgressBar {
         id: progressBar
     }
}