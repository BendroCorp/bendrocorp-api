class JobBoardMissionCompletionCriterium < ApplicationRecord
  belongs_to :child_approval_request_type, :class_name => "ApprovalKind", :foreign_key => "child_approval_request_type_id", optional: true
end
