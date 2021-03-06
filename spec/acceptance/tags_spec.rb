require 'spec_helper'

describe 'Adding and removing tags' do
  let(:article)  { Article.create }
  let(:pancakes) { Gutentag::Tag.create :name => 'pancakes' }

  it "stores new tags" do
    article.tags << pancakes

    article.tags.reload.should == [pancakes]
  end

  it "removes existing tags" do
    article.tags << pancakes

    article.tags.delete pancakes

    article.tags.reload.should == []
  end

  it "removes taggings when an article is deleted" do
    article.tags << pancakes

    article.destroy

    Gutentag::Tagging.where(
      :taggable_type => 'Article', :taggable_id => article.id
    ).count.should be_zero
  end

  it "removes taggings when a tag is deleted" do
    article.tags << pancakes

    pancakes.destroy

    Gutentag::Tagging.where(:tag_id => pancakes.id).count.should be_zero
  end
end
