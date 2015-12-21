/*
 * Copyright 2014 Canonical Ltd.
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
import Ubuntu.Components 1.1
import Ubuntu.Test 1.0

Item {
    width: units.gu(50)
    height: units.gu(100)

    Column {
        Image {
            id: test
            width: units.gu(20)
            height: units.gu(20)
            source: "/usr/share/icons/ubuntu-mobile/actions/scalable/add.svg"
            visible: source != ""
        }
        Image {
            id: bindingTest
            width: units.gu(20)
            height: units.gu(20)
            visible: source != ""
        }
    }

    UbuntuTestCase {
        name: "ImageExtension"
        when: windowShown

        SignalSpy {
            id: sourceChangeSpy
            signalName: "sourceChanged"
        }

        SignalSpy {
            id: visibleChangedSpy
            signalName: "visibleChanged"
        }

        function cleanup() {
            sourceChangeSpy.clear();
            visibleChangedSpy.clear();
        }

        // tests adjusted to reproduce bug #1401920
        function test_sourceChanged_bug1401920_data() {
            var file = "file:///usr/share/icons/ubuntu-mobile/actions/scalable/delete.svg";
            return [
                {rag: "Existing file", file: file},
                {rag: "Url with fragment", file: file + "#" + Date.now()},
            ];
        }

        function test_sourceChanged_bug1401920(data) {
            sourceChangeSpy.target = test;
            test.source = data.file;
            sourceChangeSpy.wait(400);
        }

        function test_sourceNOTIFYable() {
            /* Test source through visible to cover NOTIFYable errors */
            visibleChangedSpy.target = bindingTest;
            bindingTest.source = "/usr/share/icons/ubuntu-mobile/actions/scalable/help.svg";
            visibleChangedSpy.wait();
        }
    }
}
