# frozen_string_literal: true

allow_ssh_ingress_firewall_rule_name = attribute "allow_ssh_ingress_firewall_rule_name", {}
allow_ui_ingress_firewall_rule_name = attribute "allow_ui_ingress_firewall_rule_name", {}
database_name = attribute "database_name", {}
network_name = attribute "network_name", {}

control "instances" do
  describe "database" do
    subject do
      command "gcloud compute instances describe #{database_name} --zone us-west1-a"
    end

    specify "should block project SSH keys" do
      expect(subject.stdout).to match /key: block-project-ssh-keys.*value: 'TRUE'/m
    end

    specify "should be configured with an SSH key" do
      expect(subject.stdout).to match /key: sshKeys/
    end

    specify "should be configured with a startup script" do
      expect(subject.stdout).to match /key: startup-script/
    end

    specify "should be running" do
      expect(subject.stdout).to match /status: RUNNING/
    end

    specify "should be tagged as a database" do
      expect(subject.stdout).to match /tags:.*items:.*- db/m
    end

    specify "should be labeled as a database" do
      expect(subject.stdout).to match /labels:.*name: db/m
    end
  end
end

control "firewall rules" do
  describe "allow SSH ingress to database" do
    subject do
      command "gcloud compute firewall-rules describe #{allow_ssh_ingress_firewall_rule_name}"
    end

    specify "should allow TCP traffic on port 22" do
      expect(subject.stdout).to match /allowed:.*- IPProtocol: tcp.*ports:.*- '22'/m
    end

    specify "should be directed as ingress" do
      expect(subject.stdout).to match /direction: INGRESS/
    end

    specify "should be configured on the expected network" do
      expect(subject.stdout).to match /network:.*global\/networks\/#{network_name}/
    end

    specify "should have the lowest priority" do
      expect(subject.stdout).to match /priority: 999/
    end

    specify "should target any instance tagged as a database" do
      expect(subject.stdout).to match /targetTags:.*- db/m
    end
  end

  describe "allow UI ingress to database" do
    subject do
      command "gcloud compute firewall-rules describe #{allow_ui_ingress_firewall_rule_name}"
    end

    specify "should allow TCP traffic on port 8080" do
      expect(subject.stdout).to match /allowed:.*- IPProtocol: tcp.*ports:.*- '8080'/m
    end

    specify "should be directed as ingress" do
      expect(subject.stdout).to match /direction: INGRESS/
    end

    specify "should be configured on the expected network" do
      expect(subject.stdout).to match /network:.*global\/networks\/#{network_name}/
    end

    specify "should have the second lowest priority" do
      expect(subject.stdout).to match /priority: 998/
    end

    specify "should target instances tagged as a database" do
      expect(subject.stdout).to match /targetTags:.*- db/m
    end
  end
end
