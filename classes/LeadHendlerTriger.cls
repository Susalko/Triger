/**
 * Created by User on 31.08.2018.
 */

public with sharing class LeadHendlerTriger {
    public static Boolean beforeInsert(List<Lead> leads){

        List<String> sourceLeads = new List<String>();
        for (Lead lead: leads){
            sourceLeads.add(lead.LeadSource);
        }

        List<Campaign> listCampaigns = [
                SELECT Id, EndDate, StartDate, ParentId, Parent.Name
                FROM Campaign
                WHERE Parent.Name IN :sourceLeads
        ];

        Map<String, List<Campaign>> campaignMap = new Map<String, List<Campaign>>();
        for (Campaign c: listCampaigns){
            campaignMap.put(c.Parent.Name, new List<Campaign>()).add(c);
        }

//        Map<String, List<Campaign>> campaignMap = new Map<String, List<Campaign>>();
//        for (Campaign c: listCampaigns){
//            if (!campaignMap.containsKey(c.Parent.Name)) {
//                campaignMap.put(c.Parent.Name, new List<Campaign>());
//            }
//            campaignMap.get(c.Parent.Name).add(c);
//        }

        List<CampaignMember> campaignMembers = new List<CampaignMember>();
        for (Lead l: leads){
            if (!campaignMap.containsKey(l.LeadSource)) {
                l.addError('Error ' + l.LeadSource + ' Error ');
                continue;
            }else {
                for (Campaign c: campaignMap.get(l.LeadSource)){
                    if (l.CreatedDate.month() == c.StartDate.month()) {
                        campaignMembers.add(new CampaignMember(CampaignId = c.Id, LeadId = l.Id));
                    }
                }
            }
        }

        Database.insert(campaignMembers, true);
        return false;
    }
}