#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2018 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

module API
  module V3
    module TimeEntries
      module Schemas
        class TimeEntrySchemaRepresenter < ::API::Decorators::SchemaRepresenter
          extend ::API::V3::Utilities::CustomFieldInjector::RepresenterClass
          custom_field_injector type: :schema_representer

          def self.represented_class
            TimeEntry
          end

          schema :id,
                 type: 'Integer'

          schema :created_at,
                 type: 'DateTime'

          schema :updated_at,
                 type: 'DateTime'

          schema :spent_on,
                 type: 'Date'

          schema :hours,
                 type: 'Duration'

          schema :user,
                 type: 'User'

          schema_with_allowed_link :work_package,
                                   has_default: false,
                                   required: false,
                                   href_callback: ->(*) {
                                     allowed_work_package_href
                                   }

          schema_with_allowed_link :project,
                                   has_default: false,
                                   required: false,
                                   href_callback: ->(*) {
                                     allowed_projects_href
                                   }

          schema_with_allowed_collection :activity,
                                         type: 'TimeEntriesActivity',
                                         value_representer: TimeEntriesActivityRepresenter,
                                         has_default: true,
                                         required: true,
                                         link_factory: ->(value) {
                                           {
                                             href: api_v3_paths.time_entries_activity(value.id),
                                             title: value.name
                                           }
                                         }

          def allowed_work_package_href
            api_v3_paths.path_for(:work_packages, filters: allowed_work_packages_filters)
          end

          def allowed_work_packages_filters
            return unless represented.project

            [{ project: { operator: '=', values: [represented.project.id.to_s] } }]
          end

          def allowed_projects_href
            api_v3_paths.time_entries_available_projects
          end
        end
      end
    end
  end
end
