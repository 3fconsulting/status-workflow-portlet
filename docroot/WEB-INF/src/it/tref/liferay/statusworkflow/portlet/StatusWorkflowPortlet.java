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

package it.tref.liferay.statusworkflow.portlet;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.workflow.WorkflowException;
import com.liferay.portal.kernel.workflow.WorkflowTaskManagerUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.util.bridges.mvc.MVCPortlet;

import java.io.IOException;

import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

/**
 * Portlet implementation class StatusWorkflowPortlet
 */
public class StatusWorkflowPortlet extends MVCPortlet {

	private static final Log _log = LogFactoryUtil
			.getLog(StatusWorkflowPortlet.class);

	@Override
	public void serveResource(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) throws IOException,
			PortletException {

		String id = resourceRequest.getResourceID();

		try {

			ServiceContext serviceContext = ServiceContextFactory
					.getInstance(resourceRequest);

			long companyId = serviceContext.getCompanyId();
			long userId = serviceContext.getUserId();

			int count = 0;

			if ("countTasksUser".equals(id)) {
				try {
					count = WorkflowTaskManagerUtil.getWorkflowTaskCountByUser(
							companyId, userId, false);
				} catch (WorkflowException e) {
				}
			} else if ("countTasksUserRoles".equals(id)) {
				try {
					count = WorkflowTaskManagerUtil
							.getWorkflowTaskCountByUserRoles(companyId, userId,
									false);
				} catch (WorkflowException e) {
				}
			}

			writeJSON(resourceRequest, resourceResponse, JSONFactoryUtil
					.createJSONObject().put("count", count));

		} catch (PortalException e) {
			_log.error("Error", e);
			throw new PortletException(e);
		} catch (SystemException e) {
			_log.error("Error", e);
			throw new PortletException(e);
		}
	}

}
