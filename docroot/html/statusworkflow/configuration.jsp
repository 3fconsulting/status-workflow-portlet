<%--
/**
Copyright (C) 2002-2013 3fConsulting s.r.l.

This program is free software: you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If
not, see <http://www.gnu.org/licenses/>.
 */
--%>

<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page
	import="it.tref.liferay.statusworkflow.constant.ViewModeContstant"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>

<%@include file="/html/statusworkflow/init.jsp"%>

<%
	String viewMode = preferences.getValue("statusworkflow-viewmode",
			ViewModeContstant.STANDARD);
		 
	String colorCountTasksUserText = preferences.getValue(
			"statusworkflow-color-count-tasks-user-text", StringPool.BLANK);
	String colorCountTasksUserRolesText = preferences
			.getValue("statusworkflow-color-count-tasks-user-roles-text", StringPool.BLANK);

	String colorCountTasksUserFull = preferences.getValue(
			"statusworkflow-color-count-tasks-user-full", StringPool.BLANK);
	String colorCountTasksUserEmpty = preferences.getValue(
			"statusworkflow-color-count-tasks-user-empty", StringPool.BLANK);
	String colorCountTasksUserRolesFull = preferences
			.getValue("statusworkflow-color-count-tasks-user-roles-full", StringPool.BLANK);
	String colorCountTasksUserRolesEmpty = preferences
			.getValue("statusworkflow-color-count-tasks-user-roles-empty", StringPool.BLANK);
	
	boolean showTooltip = GetterUtil.getBoolean(preferences.getValue("statusworkflow-show-tooltip",
			null), Boolean.TRUE);
	
	String alignment = preferences
			.getValue("statusworkflow-alignment", ViewModeContstant.LEFT);
%>

<liferay-portlet:actionURL var="configurationURL"
	portletConfiguration="true">
</liferay-portlet:actionURL>

<aui:form method="post" action="<%=configurationURL.toString()%>"
	name="fm">

	<aui:input name="<%=Constants.CMD%>" type="hidden"
		value="<%=Constants.UPDATE%>" />

	<aui:select label="label-statusworkflow-viewmode"
		name="preferences--statusworkflow-viewmode--" id="viewMode">
		<aui:option
			selected="<%=viewMode.equals(ViewModeContstant.STANDARD)%>"
			label="label-statusworkflow-viewmode-standard"
			value="<%=ViewModeContstant.STANDARD%>" />
		<aui:option selected="<%=viewMode.equals(ViewModeContstant.COMPACT)%>"
			label="label-statusworkflow-viewmode-compact"
			value="<%=ViewModeContstant.COMPACT%>" />
		<aui:option selected="<%=viewMode.equals(ViewModeContstant.MODERN)%>"
			label="label-statusworkflow-viewmode-modern"
			value="<%=ViewModeContstant.MODERN%>" />
	</aui:select>

	<div id="<portlet:namespace />compactColors" style="padding: 10px;"
		class="<%=viewMode.equals(ViewModeContstant.MODERN) ? StringPool.BLANK
						: "aui-helper-hidden"%>">
		<aui:layout>
			<aui:column>
				<aui:input
					label="label-statusworkflow-viewmode-color-count-tasks-user-text"
					name="preferences--statusworkflow-color-count-tasks-user-text--"
					value="<%=colorCountTasksUserText%>" size="15" maxlength="15" />
				<aui:input
					label="label-statusworkflow-viewmode-color-count-tasks-user-full"
					name="preferences--statusworkflow-color-count-tasks-user-full--"
					value="<%=colorCountTasksUserFull%>" size="15" maxlength="15" />
				<aui:input
					label="label-statusworkflow-viewmode-color-count-tasks-user-roles-full"
					name="preferences--statusworkflow-color-count-tasks-user-roles-full--"
					value="<%=colorCountTasksUserRolesFull%>" size="15" maxlength="15" />
			
				<aui:select label="label-statusworkflow-show-tooltip"
					name="preferences--statusworkflow-show-tooltip--">
					<aui:option selected="<%=showTooltip%>" label="yes"
						value="<%=Boolean.TRUE%>" />
					<aui:option selected="<%=!showTooltip%>" label="no"
						value="<%=Boolean.FALSE%>" />
				</aui:select>

			</aui:column>
			<aui:column>
				<aui:input
					label="label-statusworkflow-viewmode-color-count-tasks-user-roles-text"
					name="preferences--statusworkflow-color-count-tasks-user-roles-text--"
					value="<%=colorCountTasksUserRolesText%>" size="15" maxlength="15" />
				<aui:input
					label="label-statusworkflow-viewmode-color-count-tasks-user-empty"
					name="preferences--statusworkflow-color-count-tasks-user-empty--"
					value="<%=colorCountTasksUserEmpty%>" size="15" maxlength="15" />
				<aui:input
					label="label-statusworkflow-viewmode-color-count-tasks-user-roles-empty"
					name="preferences--statusworkflow-color-count-tasks-user-roles-empty--"
					value="<%=colorCountTasksUserRolesEmpty%>" size="15" maxlength="15" />
				
				<aui:select label="alignment"
					name="preferences--statusworkflow-alignment--">
					<aui:option selected="<%=alignment.equals(ViewModeContstant.LEFT)%>" label="left"
						value="<%=ViewModeContstant.LEFT%>" />
					<aui:option selected="<%=alignment.equals(ViewModeContstant.CENTER)%>" label="center"
						value="<%=ViewModeContstant.CENTER%>" />
					<aui:option selected="<%=alignment.equals(ViewModeContstant.RIGHT)%>" label="right"
						value="<%=ViewModeContstant.RIGHT%>" />
				</aui:select>	
				
			</aui:column>
		</aui:layout>

	</div>

	<aui:button-row>
		<aui:button type="submit" />
	</aui:button-row>
</aui:form>

<aui:script use="aui-base,aui-color-picker">
			
	A.one('#<portlet:namespace />viewMode').on('change', function(event) {
		var currentTarget = event.currentTarget;
		if (currentTarget.val() == '<%=ViewModeContstant.MODERN%>') {
			A.one('#<portlet:namespace />compactColors').show();
		}
		else {
			A.one('#<portlet:namespace />compactColors').hide();
		}
	});
	
	var e1 = A.one('#<portlet:namespace />statusworkflow-color-count-tasks-user-text');
	var c1 = new A.ColorPicker({
		triggerParent: e1.get('parentNode'),
		zIndex: 9999,
		align: { points: [ 'lc', 'rc' ] },
		after: {
			colorChange: function(event) {
				e1.val("#"+this.get('hex'));
			}
		}
	}).render();
	c1.set('hex', e1.val().replace('#', ''));
	
	var e2 = A.one('#<portlet:namespace />statusworkflow-color-count-tasks-user-full');
	var c2 = new A.ColorPicker({
		triggerParent: e2.get('parentNode'),
		zIndex: 9999,
		align: { points: [ 'lc', 'rc' ] },
		after: {
			colorChange: function(event) {
				e2.val("#"+this.get('hex'));
			}
		}
	}).render();
	c2.set('hex', e2.val().replace('#', ''));
	
	var e3 = A.one('#<portlet:namespace />statusworkflow-color-count-tasks-user-roles-full');
	var c3 = new A.ColorPicker({
		triggerParent: e3.get('parentNode'),
		zIndex: 9999,
		align: { points: [ 'lc', 'rc' ] },
		after: {
			colorChange: function(event) {
				e3.val("#"+this.get('hex'));
			}
		}
	}).render();
	c3.set('hex', e3.val().replace('#', ''));
	
	var e4 = A.one('#<portlet:namespace />statusworkflow-color-count-tasks-user-roles-text');
	var c4 = new A.ColorPicker({
		triggerParent: e4.get('parentNode'),
		zIndex: 9999,
		align: { points: [ 'lc', 'rc' ] },
		after: {
			colorChange: function(event) {
				e4.val("#"+this.get('hex'));
			}
		}
	}).render();
	c4.set('hex', e4.val().replace('#', ''));
	
	var e5 = A.one('#<portlet:namespace />statusworkflow-color-count-tasks-user-empty');
	var c5 = new A.ColorPicker({
		triggerParent: e5.get('parentNode'),
		zIndex: 9999,
		align: { points: [ 'lc', 'rc' ] },
		after: {
			colorChange: function(event) {
				e5.val("#"+this.get('hex'));
			}
		}
	}).render();
	c5.set('hex', e5.val().replace('#', ''));
	
	var e6 = A.one('#<portlet:namespace />statusworkflow-color-count-tasks-user-roles-empty');
	var c6 = new A.ColorPicker({
		triggerParent: e6.get('parentNode'),
		zIndex: 9999,
		align: { points: [ 'lc', 'rc' ] },
		after: {
			colorChange: function(event) {
				e6.val("#"+this.get('hex'));
			}
		}
	}).render();
	c6.set('hex', e6.val().replace('#', ''));
	
</aui:script>